declare @min_mechanic int;
declare @max_mechanic int;

select @min_mechanic = min(employee#) from mechanic;
select @max_mechanic = max(employee#) from mechanic;

declare @service int;
declare @arrive_time bigint;
declare @leave_time bigint;

declare pointer cursor local 
for select service#, arrive_time, leave_time 
	from [service] s inner join visit v 
		on s.vin = v.vin and s.visit# = v.visit#;

open pointer;

fetch next from pointer into @service, @arrive_time, @leave_time;

while @@FETCH_STATUS = 0
begin
	declare @mechanic int = floor(rand() * (@max_mechanic - @min_mechanic) + @min_mechanic);
	declare @start_time bigint = floor(rand() * (@leave_time - @arrive_time) + @arrive_time);
	declare @end_time bigint = floor(rand() * (@leave_time - @start_time) + @start_time);

	insert into performance (mechanic#, service#, start_time, end_time)
	values (@mechanic, @service, @start_time, @end_time);

	fetch next from pointer into @service, @arrive_time, @leave_time; 
end;

close pointer;

deallocate pointer;