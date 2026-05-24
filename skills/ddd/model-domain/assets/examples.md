# DDD Ruby Modeling Examples

## Value Object — Money

```ruby
# lib/money.rb
class Money
  attr_reader :amount_cents, :currency

  def initialize(amount_cents, currency = "USD")
    @amount_cents = Integer(amount_cents)
    @currency = currency.upcase.freeze
    freeze
  end

  def ==(other)
    other.is_a?(Money) && amount_cents == other.amount_cents && currency == other.currency
  end

  alias eql? ==

  def hash
    [amount_cents, currency].hash
  end
end
```

- **Modeling choice:** Value object — equality by value, immutable, no database identity needed.
- **Suggested home:** `lib/money.rb`
- **Avoid:** Adding a database table or mapping identity — this is a calculation value, not an entity.

## Application Service — CreateOrder

```ruby
# lib/orders/create_order.rb
module Orders
  class CreateOrder
    Result = Struct.new(:success?, :order, :errors, keyword_init: true)

    def self.call(**args) = new(**args).call

    def initialize(user:, product_id:, quantity:)
      @user, @product_id, @quantity = user, product_id, quantity
    end

    def call
      product = Product.find(@product_id)
      order = Order.new(user: @user, product: product, quantity: @quantity)
      
      if order.save
        Result.new(success?: true, order: order, errors: [])
      else
        Result.new(success?: false, order: nil, errors: order.errors)
      end
    rescue ProductNotFoundError
      Result.new(success?: false, order: nil, errors: ["Product not found"])
    end
  end
end
```

- **Modeling choice:** Application service — coordinates persistence and follows up side effects for one use case.
- **Suggested home:** `lib/orders/create_order.rb`
- **Avoid:** Callback chains on `Order` or leaking use-case orchestration.

## Domain Event — OrderCreated

```ruby
# lib/orders/order_created_event.rb
module Orders
  class OrderCreatedEvent
    attr_reader :order_id, :occurred_at

    def initialize(order_id:)
      @order_id = order_id
      @occurred_at = Time.now.freeze
    end
  end
end
```

- **Modeling choice:** Domain event — record of something that happened in the domain.
- **Suggested home:** `lib/orders/order_created_event.rb`

## JSON Mapping (Machine Readable)

```json
{
  "aggregates": [
    {
      "name": "Order",
      "model": "Order",
      "repository": "OrderRepository",
      "services": ["OrderCreator", "OrderCanceler"],
      "events": ["order.created", "order.canceled"],
      "owner": "team-orders"
    }
  ],
  "bounded_contexts": [
    {"name": "Orders", "path": "lib/orders/*", "owner": "team-orders"},
    {"name": "Billing", "path": "lib/billing/*", "owner": "team-billing"}
  ]
}
```
