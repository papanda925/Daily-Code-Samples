$lines='H20260904','D0001APPLE ','D0002ORANGE','T00000002';$lines|%{switch($_[0]){'H'{"HEADER $_"}'D'{"DETAIL $_"}'T'{"TRAILER $_"}}}
