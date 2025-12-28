CREATE TABLE "Ingredients" (
    "name" TEXT NOT NULL,
    "price_per_unit" REAL NOT NULL, -- price per gram e.g ($4.50)
    "unit" TEXT NOT NULL, -- grams(g)
    PRIMARY KEY("name")
);

CREATE TABLE "Donuts" (
    "name" TEXT NOT NULL,
    "gluten_free" INTEGER NOT NULL,  -- 0 = no, 1 = yes
    "price" REAL NOT NULL,
    PRIMARY KEY("name")
);

CREATE TABLE "Donut_Ingredients" (
    "donut_name" TEXT NOT NULL,
    "ingredient_name" TEXT NOT NULL,
    PRIMARY KEY ("donut_name", "ingredient_name"),
    FOREIGN KEY ("donut_name") REFERENCES "Donuts"("name"),
    FOREIGN KEY ("ingredient_name") REFERENCES "Ingredients"("name")
);

CREATE TABLE "Customers" (
    "customer_id" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("customer_id")
);

CREATE TABLE "Orders" (
    "order_id" INTEGER NOT NULL,
    "customer_id" INTEGER NOT NULL,
    PRIMARY KEY("order_id"),
    FOREIGN KEY("customer_id") REFERENCES "Customers"("customer_id")
);

CREATE TABLE Order_Items (
    "order_id" INTEGER NOT NULL,
    "donut_name" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    PRIMARY KEY ("order_id", "donut_name"),
    FOREIGN KEY ("order_id") REFERENCES "Orders"("order_id"),
    FOREIGN KEY ("donut_name") REFERENCES "Donuts"("name")
);
