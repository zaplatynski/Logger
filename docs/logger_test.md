# LOGGER_TEST






 
- [UTIL_TEST_SETUP Procedure](#util_test_setup)
 
- [UTIL_TEST_TEARDOWN Procedure](#util_test_teardown)
 
- [UTIL_DISPLAY_ERRORS Procedure](#util_display_errors)
 
- [UTIL_GET_UNIQUE_SCOPE Function](#util_get_unique_scope)
 
- [UTIL_RUN_TESTS Procedure](#util_run_tests)












 
## UTIL_TEST_SETUP Procedure<a name="util_test_setup"></a>


<p>
<p>Setups test</p><p>Notes:<br /> -</p><p>Related Tickets:<br /> -</p>
</p>

### Syntax
```plsql
procedure util_test_setup
```

 





 
## UTIL_TEST_TEARDOWN Procedure<a name="util_test_teardown"></a>


<p>
<p>Setups test</p><p>Notes:<br /> -</p><p>Related Tickets:<br /> -</p>
</p>

### Syntax
```plsql
procedure util_test_teardown
```

 





 
## UTIL_DISPLAY_ERRORS Procedure<a name="util_display_errors"></a>


<p>
<p>Displays errors</p><p>Notes:<br /> -</p><p>Related Tickets:<br /> -</p>
</p>

### Syntax
```plsql
procedure util_display_errors
```

 





 
## UTIL_GET_UNIQUE_SCOPE Function<a name="util_get_unique_scope"></a>


<p>
<p>Returns unique scope</p><p>Notes:</p><ul>
<li>This is useful when trying to back reference which log was just inserted</li>
<li>Should look in logger_logs_5_mins since recent</li>
</ul>
<p>Related Tickets:<br /> -</p>
</p>

### Syntax
```plsql
function util_get_unique_scope
  return varchar2
```

 





 
## UTIL_RUN_TESTS Procedure<a name="util_run_tests"></a>


<p>
<p>Runs all the tests and displays errors</p><p>Notes:<br /> -</p><p>Related Tickets:<br /> -</p>
</p>

### Syntax
```plsql
procedure util_run_tests
```

 





 
