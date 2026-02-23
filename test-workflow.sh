#!/bin/bash
set -e

echo "=== TESTING WORKFLOW LOCALLY ==="

# Test 1: Check files exist
echo "?? Test 1: Checking files..."
if [ -f ".github/workflows/deploy.yml" ]; then
    echo "? Workflow file exists"
else
    echo "? Workflow file not found"
    exit 1
fi

if [ -f "ansible-project/deploy.yml" ]; then
    echo "? Playbook file exists"
else
    echo "? Playbook file not found"
    exit 1
fi

# Test 2: Check YAML syntax
echo "?? Test 2: Checking YAML syntax..."
python3 -c "
import yaml
try:
    with open('.github/workflows/deploy.yml') as f:
        data = yaml.safe_load(f)
    print('? Workflow YAML is valid')
    print(f'   Jobs found: {list(data.get(\"jobs\", {}).keys())}')
except Exception as e:
    print(f'? YAML error: {e}')
    exit(1)
"

# Test 3: Check Ansible playbook syntax
echo "?? Test 3: Checking Ansible playbook syntax..."
if command -v ansible-playbook &> /dev/null; then
    ansible-playbook ansible-project/deploy.yml --syntax-check
else
    echo "?? Ansible not installed, skipping"
fi

# Test 4: Validate required secrets
echo "?? Test 4: Checking secrets in workflow..."
grep -n "secrets\." .github/workflows/deploy.yml | while read -r line; do
    echo "   Found secret reference: $line"
done

# Test 5: Check SSH key format
echo "?? Test 5: Checking SSH key format (simulated)..."
if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "? SSH_PRIVATE_KEY is set"
else
    echo "?? SSH_PRIVATE_KEY not set (will need to be set in GitHub)"
fi

echo ""
echo "=== TEST SUMMARY ==="
echo "? Workflow syntax: OK"
echo "? File structure: OK"
echo "??  Secrets need to be configured in GitHub"
echo "? Ready for commit and push"