declare @min_arrive_time bigint;
declare @max_arrive_time bigint;
declare @a_day_in_seconds int;
declare @max_odometer int;
set @min_arrive_time = 1680480000;
set @max_arrive_time = 1712102401;
set @a_day_in_seconds = 86400;
set @max_odometer = 999999;

declare @diagnosis table (id int identity(0, 1), diagnostic varchar(255), diagnosis_fee float);
-- 1. Flat tire
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('You got a flat tire', 0);

-- 2. Dead battery
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Battery failure', 10);

-- 3. Overheating engine
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Engine overheating', 10.5);

-- 4. Ignition system issues
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Faulty spark plugs or ignition coils', 20);

-- 5. Fuel system problems
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Fuel pump malfunction', 10);

-- 6. Electrical failure
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Wiring issues or sensor failures', 25);

-- 7. Clutch failure
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Worn-out clutch', 5);

-- 8. Lost keys
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Misplaced car keys', 0);

-- 9. Tire alignment issues
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Uneven tire wear', 5);

-- 10. Engine belt failure
INSERT INTO @diagnosis (diagnostic, diagnosis_fee)
VALUES ('Broken serpentine belt', 10);

declare pointer cursor local
for select vin from automobile;
open pointer;

declare @vin char(17);

fetch next from pointer into @vin;

while @@FETCH_STATUS = 0
begin
	declare @nvisits int;
	declare @visit int;
	declare @last_visit_time bigint;
	set @nvisits = floor(rand() * 5);
	set @visit = 0;
	set @last_visit_time = @min_arrive_time;

	while @visit <= @nvisits
	begin
		declare @arrive_time bigint;
		declare @leave_time bigint;
		declare @odometer float;
		declare @diagnostic varchar(255);
		declare @diagnosis_fee float;

		set @arrive_time = floor(rand() * (@max_arrive_time - @last_visit_time) + @last_visit_time);
		set @last_visit_time = @arrive_time;
		set @leave_time = floor(rand() * (@a_day_in_seconds) + @arrive_time);
		set @odometer = round(rand() * @max_odometer, 1);
		select @diagnostic = diagnostic, @diagnosis_fee = diagnosis_fee
		from @diagnosis
		where id = floor(rand() * 9);

		insert into visit (vin, visit#, arrive_time, leave_time, odometer, diagnostic, diagnosis_fee, total_cost) 
		values (@vin, @visit, @arrive_time, @leave_time, @odometer, @diagnostic, @diagnosis_fee, 0);

		set @visit = @visit + 1;
	end;
	fetch next from pointer into @vin;
end;

close pointer;

deallocate pointer;