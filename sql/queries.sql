--  Create view of visits in this month
create view current_month_visit
as 
	select *
	from visit
	where month(dbo.to_datetime(arrive_time)) = month(getdate())
		and year(dbo.to_datetime(arrive_time)) = year(getdate());

-- Get daily number of visits this month
select day(dbo.to_datetime(arrive_time)) as [day],
	count(visit#) as [number of visits]
from current_month_visit
group by day(dbo.to_datetime(arrive_time))

-- Get this month's revenue
select sum(total_cost) as [Revenue]
from current_month_visit

-- Get the list of services in a visit
with specific_visit (micro_service#, part#, part_quantity) as (
	select micro_service#, part#, part_quantity
	from [service]
	where vin = '19UUA56843A209914'
		and visit# = 0
)
select ms.[name] as [Service],
	p.[name] as [Part],
	sv.part_quantity as [Quantity]
from specific_visit sv
inner join micro_service ms on sv.micro_service# = ms.micro_service#
inner join part p on sv.part# = p.part#

-- Get the list of mechanic participating in a visit
with specific_visit (service#) as (
	select service#
	from [service]
	where vin = '19UUA56843A209914'
		and visit# = 0
)
select e.employee# as [ID],
	e.[name] as [Name],
	e.phone# as [Phone number]
from specific_visit sv
inner join performance p on sv.service# = p.service#
inner join employee e on p.mechanic# = e.employee#;

-- Get the list of services & their number of usage this month
select ms.[name],
	count(ms.micro_service#) as [Number of usage]
from [service] s
inner join current_month_visit cmv on s.vin = cmv.vin and s.visit# = cmv.visit#
inner join micro_service ms on s.micro_service# = ms.micro_service#
group by ms.[name], ms.micro_service#;

-- Get the portion of different models this month
with model_count (model#, [Number of model]) as (
	select model#,
		count(model#)
	from automobile a
	inner join current_month_visit cmv on a.vin = cmv.vin
	group by model#
)
select m.[name] as [Model],
	m.[year] as [Year],
	b.[name] as [Brand],
	mc.[Number of model]
from model m
inner join model_count mc on m.model# = mc.model#
inner join brand b on m.brand# = b.brand#
order by [Number of model] desc;

-- Get the average time of a visit this month
select avg(leave_time - arrive_time)/(60 * 60) as [Average hours]
from current_month_visit
where leave_time is not null;

-- Get the average time of different service this month
with avg_micro_service (micro_service#, avg_hours) as (
	select micro_service#,
		round(cast(avg(end_time - start_time) as float)/(60 * 60),2) as avg_hours
	from [service] s
	inner join current_month_visit cmv on s.vin = cmv.vin and s.visit# = cmv.visit#
	inner join performance p on s.service# = p.service#
	where leave_time is not null
	group by micro_service#
)
select ms.[name] as [Service],
	avg_hours as [Average hours]
from avg_micro_service ams
inner join micro_service ms on ams.micro_service# = ms.micro_service#;

-- Get the list of members who haven't visited for more than a year
with infrequent_automobile (vin) as (
	select vin
	from visit
	group by vin
	having dbo.to_epoch(getdate()) - max(arrive_time) >= 365 * 24 * 60 * 60
)
select * 
from [member] m
inner join (
	select distinct member#
	from automobile a
	inner join infrequent_automobile ia on a.vin = ia.vin
	 A member can possess of many automobile
	except
	(
		select member#
		from member
		except 
		select distinct member#
	from automobile a
	inner join infrequent_automobile ia on a.vin = ia.vin
	)
) as infrequent_member on m.member# = infrequent_member.member#;