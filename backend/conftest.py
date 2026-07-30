import os

# Disable AWS-only validation for tests that don't have AWS credentials.
os.environ.setdefault("AWS_ONLY_MODE", "false")
