--  TABLE  CREATION

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(25) NOT NULL,
    reg_date DATE
);

-- Create restaurants table
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(60) NOT NULL,
    city VARCHAR(20),
    opening_hours VARCHAR(60)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_item VARCHAR(100),
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    order_status VARCHAR(60) DEFAULT 'Pending',
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Create riders table
CREATE TABLE riders (
    rider_id INT PRIMARY KEY,
    rider_name VARCHAR(60) NOT NULL,
    sign_up DATE
);

-- Create deliveries table
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    delivery_status VARCHAR(20) DEFAULT 'Pending',
    delivery_time TIME,
    rider_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);