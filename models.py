from typing import Optional, List
from sqlmodel import SQLModel, Field, Relationship

class MenuItem(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    description: str
    price: float
    available: bool = True

class OrderItem(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    order_id: int = Field(foreign_key="order.id")
    menu_item_id: int = Field(foreign_key="menuitem.id")
    quantity: int = 1
    menu_item: Optional[MenuItem] = Relationship()

class Order(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    customer_name: str
    phone: str
    total_price: float = 0.0
    status: str = "pending"
    items: List[OrderItem] = Relationship()
