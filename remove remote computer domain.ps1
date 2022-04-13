Remove-Computer -UnjoinDomaincredential csb.local\jlmagee -PassThru -Verbose -Restart

Add-Computer -DomainName csb.local -Restart