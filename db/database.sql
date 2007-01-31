drop table if exists calendars;
drop table if exists events;

create table calendars (
	id				int					not null auto_increment,
	name			varchar(100)		not null,
	description		text				not null,
	ical_url		varchar(250)		not null,
	color			varchar(100)		not null,
	primary key (id)
);

insert into calendars values(1, 'Diocesan Events',             'Diocesan Events description',             'http://www.google.com/calendar/ical/mcbm717egpim1lumu3ipoi76t8@group.calendar.google.com/public/basic#.ics', 'white');
insert into calendars values(2, 'Cathedral Events',            'Cathedral Events description',            'http://www.google.com/calendar/ical/4nq6u759dndkgnbprhsofpc9r0@group.calendar.google.com/public/basic#.ics', 'white');
insert into calendars values(3, 'Bishop Visitations',          'Bishop Visitations description',          'http://www.google.com/calendar/ical/8o4iekmki3q3fk4rtneh9jkibk@group.calendar.google.com/public/basic#.ics', 'white');
insert into calendars values(4, 'Leadership Institute Events', 'Leadership Institute Events description', 'http://www.google.com/calendar/ical/totqvtet64dc6sh5rui06tmlho@group.calendar.google.com/public/basic#.ics', 'white');
insert into calendars values(5, 'Parish Events',               'Parish Events description',               'http://www.google.com/calendar/ical/gs5r43j1a05tcbgrg7g4hv3lv8@group.calendar.google.com/public/basic#.ics', 'white');
insert into calendars values(6, 'Youth Events',                'Youth Events description',                'http://www.google.com/calendar/ical/tsr9pn0764seljjbd6mgf3i5i4@group.calendar.google.com/public/basic#.ics', 'white');
insert into calendars values(7, 'Wapiti Events',               'Wapiti Events description',               'http://www.google.com/calendar/ical/aod57olnmnne4brvlqc01d6lp8@group.calendar.google.com/public/basic#.ics', 'white');


create table events (
	id					int					not null auto_increment,
	start_date			datetime			not null,
	end_date			datetime			not null,
	title				varchar(100)		not null,
	description			text				not null,
	content_id			int					not null,
	report_content_id	int					not null,
	location			varchar(100)		not null,
	approved			tinyint(1)			not null default 0,
	calendar_id			int					not null,
	primary key (id)
);
