delete from supply;
delete from supply;
dbcc checkident ('supply', reseed, -1);

declare @max_garage int;
declare @max_distributor int;
declare @min_order_time bigint = dbo.to_epoch('12/5/2015');
declare @max_order_time bigint = dbo.to_epoch('1/1/2024');
declare @a_day_in_seconds int = 86400;
declare @max_quantity int = 501;

select @max_garage = count(*) from garage;
select @max_distributor = count(*) from distributor;

declare pointer cursor local
for select garage#, part# from inventory;
open pointer;

declare @garage int;
declare @part int;

fetch next from pointer into @garage, @part;

while @@FETCH_STATUS = 0
begin
	declare @supplier int;
	declare @quantity int = floor((rand() * @max_quantity) + 1);
	declare @order_time bigint = floor((rand() * (@max_order_time - @min_order_time)) + @min_order_time);
	declare @arrive_time bigint = @order_time + @a_day_in_seconds;
	if round(rand(), 0) = 0
		begin
			set @supplier = floor(rand() * @max_garage);
			insert into supply (garage#, part#, order_time, arrive_time, quantity, supplier_garage#) 
			values (@garage, @part, @order_time, @arrive_time, @quantity, @supplier);
		end
	else
		begin
			set @supplier = floor(rand() * @max_distributor);
			insert into supply (garage#, part#, order_time, arrive_time, quantity, supplier_distributor#) 
			values (@garage, @part, @order_time, @arrive_time, @quantity, @supplier);
		end;
	fetch next from pointer into @garage, @part;
end;

select count(*) from supply;