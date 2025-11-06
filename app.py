from flask import Flask, request, jsonify
from sqlmodel import Session, select
from models import MenuItem, Order, OrderItem
from database import init_db, engine

app = Flask(__name__)

@app.before_request
def on_startup():
    init_db()

@app.get("/menu")
def get_menu():
    with Session(engine) as session:
        items = session.exec(select(MenuItem).where(MenuItem.available == True)).all()
        return jsonify([item.dict() for item in items])

@app.post("/orders")
def create_order():
    data = request.get_json()
    customer_name = data.get("customer_name")
    phone = data.get("phone")
    items = data.get("items", [])

    if not items:
        return jsonify({"error": "Order must contain at least one item"}), 400

    with Session(engine) as session:
        total = 0.0
        order = Order(customer_name=customer_name, phone=phone)
        session.add(order)
        session.commit()

        for item in items:
            menu_item = session.get(MenuItem, item["menu_item_id"])
            if not menu_item or not menu_item.available:
                return jsonify({"error": f"Item {item['menu_item_id']} not available"}), 400

            qty = item.get("quantity", 1)
            total += menu_item.price * qty
            order_item = OrderItem(order_id=order.id, menu_item_id=menu_item.id, quantity=qty)
            session.add(order_item)

        order.total_price = total
        session.add(order)
        session.commit()

        return jsonify({"message": "Order created", "order_id": order.id, "total": total})

@app.get("/orders")
def list_orders():
    with Session(engine) as session:
        orders = session.exec(select(Order)).all()
        return jsonify([order.dict() for order in orders])

if __name__ == "__main__":
    app.run(debug=True)
