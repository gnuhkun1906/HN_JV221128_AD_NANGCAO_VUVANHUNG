create database QLBH_VuVanHung;
drop database qlbh_vuvanhung;
use qlbh_vuvanhung;
-- 1.Tạo bảng và chèn dữ liệu 
create table customer(
cId int primary key ,
`name` varchar(25),
cAge tinyint 
);

create table `order`(
oId int primary key ,
cId int,
foreign key(cId) references customer(cId),
oDate datetime,
oTotalPrice int
);

create table product(
pId int primary key,
pName varchar(25),
pPrice int
);

create table orderDetail(
oId int,
foreign  key(oId) references `order`(oId),
pId int,
foreign key(pId) references product(pId),
odQTy int 
);

insert into customer values
(1,"Minh Quan",10),
(2,"Ngoc Oanh",20),
(3,"Hong Ha",50);

insert into `order` values
(1,1,"2006-03-21",null),
(2,2,"2006-03-23",null),
(3,1,"2006-03-16",null);

insert into product values
(1,"May Giat",3),
(2,"Tu lanh",5),
(3,"Dieu Hoa",7),
(4,"Quat",1),
(5,"Bep Dien",2);

insert into orderdetail values
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

-- 2.Hiển thị các thoong tin của bảng order
select * from `order` order by odate desc;

-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất
select pName, pPrice from product
where pPrice=(select max(pPrice) from product);
-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm 
select c.`name`,p.pName 
from customer c join `order` o
on c.cId=o.cId join orderDetail od
on od.oId=o.oId join product p
on od.pId=p.pId;

-- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select `name` from customer
where cId not in  (select c.cId from customer c join `order` o
on c.cId=o.cId join orderDetail od
on od.oId=o.oId join product p
on od.pId=p.pId);

-- 6. Hiển thị chi tiết của từng hóa đơn
select od.oId,o.odate,od.odQTY,p.pName,p.pPrice
from `orderdetail` od join `order` o
on o.oId=od.oId join product p
on od.pId=p.pId;

-- 7.Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
select o.oId, o.oDate,sum((od.odQTY*p.pPrice)) as `Total`
from `product` p join orderDetail od
on p.pId = od.pId join `order` o
on od.oId=o.oId group by o.oId;

-- 8.Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị
create view `Sales`
as select sum((od.odQTY*p.pPrice)) as `Sales`
from `product` p join orderDetail od
on p.pId = od.pId join `order` o
on od.oId=o.oId;

-- 9.Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng.
alter table orderdetail
drop foreign key orderdetail_ibfk_1;
alter table orderdetail
drop foreign key orderdetail_ibfk_2;

alter table `order`
drop foreign key order_ibfk_1;
alter table `order`
drop primary key;
alter table customer
drop primary key;
alter table product
drop primary key;

-- 10.Tạo một trigger tên là cusUpdate trên bảng Customer,
-- sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo: .
DROP TRIGGER IF EXISTS cusUpdate;
delimiter //
create trigger cusUpdate
after update on customer 
for each row
begin 
update `order` 
set 
cId=NEW.cId
where cId=OLD.cId;
end
// delimiter ;

update customer set cId=4 where cId=1;
-- 11.Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của
-- một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên
-- vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong
-- bảng OrderDetail:
drop procedure if exists proc_delProcedure;
delimiter //
create procedure proc_delProcedure
( in proName varchar(25))
begin
delete from orderDetail as `od` where (od.pId=(select pId from product where pName=proName));
delete from product where pName=proName;
end
// delimiter ;
call proc_delProcedure("BEP DIEN");








