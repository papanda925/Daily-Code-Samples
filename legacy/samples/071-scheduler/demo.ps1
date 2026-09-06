"Logical processors=$([Environment]::ProcessorCount)"
Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 4
