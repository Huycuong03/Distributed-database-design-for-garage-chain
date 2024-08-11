create function dbo.is_valid_epoch(@date bigint) returns int
as begin
	if (@date > cast(datediff(s,'1970-01-01 00:00:00',getdate()) as bigint)) return 0;
	return 1;
end;