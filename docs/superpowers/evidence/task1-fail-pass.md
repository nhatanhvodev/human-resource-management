# Task 1 Fail -> Pass Evidence

This evidence demonstrates that `HrmsApplicationContextIT` fails when application bootstrap is missing and passes when bootstrap is restored.

## Command (same for both runs)

```powershell
mvn -Dtest=HrmsApplicationContextIT test
```

## How fail evidence was produced

1. Temporarily moved `src/main/java/com/company/hrms/HrmsApplication.java` out of the source tree.
2. Ran the command above and captured output.
3. Restored `HrmsApplication.java` immediately after the run.

See: `docs/superpowers/evidence/task1-fail.log`

Key lines:

- `exit_code=1`
- `[INFO] Running com.company.hrms.HrmsApplicationContextIT`
- `Unable to find a @SpringBootConfiguration`
- `[INFO] BUILD FAILURE`

## How pass evidence was produced

1. With `HrmsApplication.java` restored, ran the same command again and captured output.

See: `docs/superpowers/evidence/task1-pass.log`

Key lines:

- `exit_code=0`
- `[INFO] Running com.company.hrms.HrmsApplicationContextIT`
- `[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0`
- `[INFO] BUILD SUCCESS`
