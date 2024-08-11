create function dbo.to_datetime(@epoch bigint) returns datetime
as begin
	return dateadd(s, @epoch, '1970-01-01 00:00:00');
end;