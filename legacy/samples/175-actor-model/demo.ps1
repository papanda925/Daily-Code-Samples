$q=[Collections.Concurrent.BlockingCollection[string]]::new();'A','B','STOP'|%{$q.Add($_)};while(($m=$q.Take())-ne'STOP'){"Actor received: $m"};$q.Dispose()
