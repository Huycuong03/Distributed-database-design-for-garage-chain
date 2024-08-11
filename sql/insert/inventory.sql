delete from inventory;

declare @max_garage int;
declare @max_part int;
declare @max_quantity int;
declare @min_min_quantity int;
declare @max_min_quantity int;
declare @min_price int;
declare @max_price int;

select @max_garage = count(*) from garage;
select @max_part = count(*) from part;
set @max_quantity = 501;
set @min_min_quantity = 20;
set @max_min_quantity = 51;
set @min_price = 50;
set @max_price = 501;

declare @garage int;
set @garage = 0;
while @garage < @max_garage
begin
	declare @part int;
	set @part = 0;
	while @part < @max_part
	begin
		declare @quantity int;
		declare @min_quantity int;
		declare @price int;

		set @quantity = floor(rand() * @max_quantity);
		set @min_quantity = floor((rand() * (@max_min_quantity - @min_min_quantity)) + @min_min_quantity);
		set @price = floor((rand() * (@max_price - @min_price)) + @min_price);
		insert into inventory (garage#, part#, quantity, min_quantity, price) 
		values (@garage, @part, @quantity, @min_quantity, @price);
		set @part = @part + 1;
	end;
	set @garage = @garage + 1;
end;

select count(*) from inventory;