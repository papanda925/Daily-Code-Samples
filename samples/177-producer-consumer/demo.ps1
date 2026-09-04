$q=[Collections.Concurrent.BlockingCollection[int]]::new();1..5|%{$q.Add($_);"Produced $_"};$q.CompleteAdding();foreach($x in$q.GetConsumingEnumerable()){"Consumed $x"};$q.Dispose()
