/*
	1. Tạo database Trigger_Demo
    2. Tạo bảng Product bao gồm các trường: productId(pk), productName, price(float)
    3. Tạo 1 trigger được kích hoạt trước khi sự kiện insert được xảy ra trên bảng Product,
    để chặn xử lý chặn insert các dữ liệu có price nhỏ hơn 0
    4. Tạo 1 trigger được kích hoạt trước khi sự kiện update được xảy ra trên bảng Product,
    để xử lý gán lại price = 0 nếu như price cập nhật < 0
*/
-- 1. Tạo database Trigger_Demo
create database Trigger_Demo;
use Trigger_Demo;

-- 2. Tạo bảng Product bao gồm các trường: productId(pk), productName, price(float)
drop table product;
create table Product(
	productId int auto_increment primary key,
    productName varchar(100) unique not null,
    price float
);

-- 3. Tạo 1 trigger được kích hoạt trước khi sự kiện insert được xảy ra trên bảng Product,
-- để chặn xử lý chặn insert các dữ liệu có price nhỏ hơn 0
DELIMITER //
drop trigger before_insert_product;
create trigger before_insert_product before insert on Product for each row
BEGIN
	if(NEW.price < 0) then
		signal SQLSTATE '02000' set MESSAGE_TEXT = 'Giá trị Price đang nhập vào bé hơn không';
    end if;
END //
DELIMITER ;

insert into Product(productName, price)
values('Quần áo', 20.5);

-- 4. Tạo 1 trigger được kích hoạt trước khi sự kiện update được xảy ra trên bảng Product,
-- để xử lý gán lại price = 0 nếu như price cập nhật < 0
DELIMITER //
-- drop trigger before_update_product;
create trigger before_update_product before update on Product for each row
BEGIN 
	if(NEW.price < 0) then
		set NEW.price = 0;
    end if;
END //
DELIMITER ;

update Product
set price = -12 where productId = 1;
select * from product;