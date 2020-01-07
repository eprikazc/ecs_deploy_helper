This is scaffolding for deploying Django application to ECS.
Usage:
- Run: `cp .env.example .env`
- Set correct values in .env file
- Run:
```
source .env
terraform apply
./push -b -d
```
