This is scaffolding for deploying Django application to ECS.
Usage:
- Run: `cp .env.example .env`
- Set correct values in .env file
- Run:
```
source .env
terraform apply
./push -b # Build new version of the app, and push it to ECR
./push -m # Run task with migrations, if needed
./push -d # Trigger app deployment
```
