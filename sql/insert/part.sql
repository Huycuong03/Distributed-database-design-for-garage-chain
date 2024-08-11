delete from part;
dbcc checkident ('part', reseed, -1);
DECLARE @carparts table (id int identity(0,1), [name] varchar(50));
INSERT INTO @carparts ([name])
VALUES
  ('Engine'),
  ('Brakes'),
  ('Transmission'),
  ('Headlights'),
  ('Tires'),
  ('Windshield'),
  ('Wiper Blades'),
  ('Battery'),
  ('Air Filter'),
  ('Spark Plugs'),
  ('Oil Filter'), 
  ('Alternator'),
  ('Starter Motor'),
  ('Radiator'),
  ('Shock Absorbers'),
  ('Struts'),
  ('Suspension System'),
  ('Exhaust System'),
  ('Wheels'),
  ('Steering Wheel'),
  ('Dashboard'),
  ('Seats'),
  ('Door Locks'),
  ('Audio System'),
  ('Wiper Fluid'),
  ('Cabin Air Filter'),
  ('Spark Plug Wires'),
  ('Distributor Cap'),
  ('Oxygen Sensor'),
  ('Fuel Pump'),
  ('Fuel Filter'),
  ('Thermostat'),
  ('Coolant Hoses'),
  ('Serpentine Belt'),
  ('Timing Belt'),
  ('Brake Pads'),
  ('Brake Rotors'),
  ('Brake Calipers'),
  ('Brake Lines'),
  ('Headlight Bulbs'),
  ('Tail Lights'),
  ('Turn Signals'),
  ('Fog Lights'),
  ('Windshield Wipers'),
  ('Window Tints'),
  ('Floor Mats'),
  ('Car Cover'),
  ('Spoiler'),
  ('Tow Hitch'),
  ('Roof Rack');

insert into part 
select p.[name], b.brand#
from @carparts p, brand b;

select count(*) from part;