create function dbo.to_epoch(@datetime datetime) returns bigint
as begin
	return cast(datediff(s, '1970-01-01 00:00:00', @datetime) as bigint);
end;