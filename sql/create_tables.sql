create table brand(
	brand# int identity(0,1) primary key,
	[name] varchar(50) not null unique
);

create table model(
	model# int identity(0,1) primary key,
	[name] varchar(50) not null,
	[year] int not null check ([year] >= 1769 and [year] <= year(getdate())),
	brand# int not null references brand (brand#) on delete cascade,
	unique (brand#, model#, [year])
);

create table part(
	part# int identity(0,1) primary key,
	[name] varchar(50) not null,
	brand# int not null references brand (brand#) on delete cascade,
	unique ([name], brand#)
);

create table distributor(
	distributor# int  identity(0,1) primary key,
	[name] varchar(50) not null,
	phone# char(10) not null,
	email varchar(50) not null,
	[address] varchar(100) not null
);

create table micro_service(
	micro_service# int identity(0,1) primary key,
	[name] varchar(100) not null unique,
	charge_per_hour float not null check (charge_per_hour >= 0),
	min_hour float not null check(min_hour >= 0),
	max_hour float not null check(max_hour >= 0)
);

create table garage(
	garage# int identity(0,1) primary key,
	[name] varchar(50) not null,
	phone# char(10) not null,
	email varchar(50) not null,
	[address] varchar(100) not null
);

create table inventory(
	garage# int references garage (garage#) on delete cascade,
	part# int references part (part#) on delete cascade,
	quantity int not null check (quantity >= 0),
	min_quantity int not null check(min_quantity >= 0),
	price float not null check(price >= 0),
	primary key (garage#, part#)
);

create table supply (
	supply# int identity (0,1) primary key,
	supplier_garage# int references garage (garage#),
	supplier_distributor# int references distributor (distributor#),
	garage# int not null,
	part# int not null,
	order_time bigint not null check (dbo.is_valid_epoch(order_time) = 1), 
	arrive_time bigint check (arrive_time is null or dbo.is_valid_epoch(arrive_time) = 1), 
	quantity int not null check (quantity >= 0),
	foreign key (garage#, part#) references inventory (garage#, part#),
	constraint valid_supplier check (
		(supplier_garage# is not null and supplier_distributor# is null) or
		(supplier_garage# is null and supplier_distributor# is not null)
	),
	constraint valid_arrive_time check (arrive_time is null or arrive_time > order_time)
);

create table employee(
	employee# int identity(0,1) primary key,
	garage# int not null references garage (garage#) on delete cascade,
	[name] varchar(50) not null,
	gender char(1) not null check (gender = 'm' or gender = 'f'),
	dob bigint not null check (dbo.is_valid_epoch(dob) = 1), 
	phone# char(10) not null,
	email varchar(50),
	hire_time bigint not null check (dbo.is_valid_epoch(hire_time) = 1)
);

create table manager(
	employee# int primary key references employee (employee#) on delete cascade,
	compensation float not null check (compensation >= 0)
);

create table receptionist(
	employee# int primary key references employee (employee#) on delete cascade,
	compensation float not null check (compensation >= 0)
);

create table mechanic(
	employee# int primary key references employee (employee#) on delete cascade,
	compensation float not null check (compensation >= 0),
);

create table [member](
	member# int identity(0,1) primary key,
	[name] varchar(50) not null,
	gender char(1) not null check (gender = 'm' or gender = 'f'),
	dob bigint not null check(dbo.is_valid_epoch(dob) = 1),
	phone# char(10) not null,
	email varchar(50),
	register_time bigint not null check (dbo.is_valid_epoch(register_time) = 1),
	point int default 0 check (point >= 0),
	receptionist# int references receptionist (employee#) on delete set null
);

create table automobile(
	vin char(17) primary key,
	plate# char(9),
	model# int not null references model (model#),
	member# int references [member] (member#) on delete set null,
);

create table visit(
	vin char(17) references automobile (vin) on delete cascade,
	visit# int,
	arrive_time bigint not null check(dbo.is_valid_epoch(arrive_time) = 1),
	leave_time bigint check(leave_time is null or dbo.is_valid_epoch(leave_time) = 1),
	odometer float not null check(odometer >= 0),
	diagnostic varchar(256) not null,
	diagnosis_fee float default 0 check (diagnosis_fee >= 0),
	total_cost float not null check (total_cost >= 0), 
	primary key (vin, visit#),
	constraint valid_leave_time check (leave_time is null or leave_time > arrive_time)
);

create table [service](
	service# int identity(0,1) primary key,
	micro_service# int not null references micro_service (micro_service#),
	vin char(17) not null,
	visit# int not null,
	part# int not null references part (part#),
	part_quantity int not null check (part_quantity >= 0),
	foreign key (vin, visit#) references visit (vin, visit#),
	unique (vin, visit#, micro_service#)
);

create table performance(
	mechanic# int references mechanic (employee#),
	service# int references [service] (service#),
	start_time bigint not null check (dbo.is_valid_epoch(start_time) = 1),
	end_time bigint check (end_time is null or dbo.is_valid_epoch(end_time) = 1),
	primary key (mechanic#, service#),
	constraint valid_end_time check (end_time is null or end_time > start_time)
);