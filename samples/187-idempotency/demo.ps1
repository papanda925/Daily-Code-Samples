$seen=[Collections.Generic.HashSet[string]]::new();function P($k){if(-not$seen.Add($k)){"duplicate ignored: $k"}else{"processed: $k"}};P req-001;P req-001;P req-002
