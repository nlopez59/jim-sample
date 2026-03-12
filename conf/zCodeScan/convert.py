import json

# Load your existing zCodescan JSON
with open("clean.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# Severity mapping from cleanCodeAttribute to Sonar severity
severity_map = {
    "MAINTAINABILITY": "MAJOR",
    "MODULAR": "MINOR",
    "SECURITY": "CRITICAL",
    # Add more mappings if needed
}

# Prepare the Sonar-compatible issues container
sonar_issues = {"issues": []}

# Ensure we have a list of issues
issues = data if isinstance(data, list) else [data]

for issue in issues:
    # Determine severity
    severity = severity_map.get(issue.get("cleanCodeAttribute", "").upper(), "MAJOR")
    
    # Build Sonar issue
    sonar_issue = {
        "engineId": "zcodescan",
        "ruleId": issue.get("id", "unknownRule"),
        "severity": severity,
        "type": "CODE_SMELL",
        "primaryLocation": {
            "message": issue.get("description", issue.get("name", "")),
            "filePath": issue.get("filePath", ""),
            "textRange": {
                "startLine": issue.get("line", 1),
                "endLine": issue.get("line", 1),
                "startColumn": 0,
                "endColumn": 0
            }
        }
    }
    
    sonar_issues["issues"].append(sonar_issue)

# Write to Sonar-compatible JSON file
with open("sonar_external_issues.json", "w", encoding="utf-8") as f:
    json.dump(sonar_issues, f, indent=2)

print("Converted to Sonar-compatible external issues JSON.")
