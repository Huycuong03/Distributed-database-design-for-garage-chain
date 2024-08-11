declare @max_micro_service int;
declare @max_part int;
declare @max_quantity int;

select @max_micro_service = count(*) from micro_service;
select @max_part = count(*) from part;
select @max_quantity = 5;

declare pointer cursor local 
for select vin, visit# from visit;

declare @plate char(17);
declare @visit int;

open pointer;

fetch next from pointer into @plate, @visit;

while @@FETCH_STATUS = 0
begin
	declare @micro_service int = floor(rand() * @max_micro_service);
	declare @part int = floor(rand() * @max_part);
	declare @quantity int = floor(rand() * @max_quantity);

	insert into [service] (vin, visit#, micro_service#, part#, part_quantity)
	values (@plate, @visit, @micro_service, @part, @quantity);

	fetch next from pointer into @plate, @visit;
end;

close pointer;

deallocate pointer;