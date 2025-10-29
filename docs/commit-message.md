# Commit Message Rules

## Format

```
<type>(<scope>): <subject>
```

### Optional Extended Format

You can include additional context or reasoning in the commit body.
For example:

```
<type>(<scope>): <subject>

Details:
- What changed and why
- Any potential side effects or notes for reviewers
```

## Types

| Type         | Description                                           |
| ------------ | ----------------------------------------------------- |
| **add**      | Introduce a new feature, package, or file             |
| **update**   | Update an existing feature, dependency, or package    |
| **change**   | Modify behavior or configuration without fixing a bug |
| **fix**      | Fix a bug or issue                                    |
| **perf**     | Improve performance or efficiency                     |
| **refactor** | Refactor code without changing behavior               |
| **docs**     | Documentation changes only                            |
| **ci**       | Continuous Integration or build-related changes       |
| **config**   | Changes to configuration files or settings            |
| **remove**   | Remove an unused or deprecated component              |

## Scope

- `pkg-<name>`: A specific package build script
- `docs`: Documentation-related change
- `config`: Configuration or environment setup
- `tools`: Development tools or helper scripts

## Examples

- `add(pkg-bash): Add Bash package`
- `update(pkg-bash): Update Bash to version 5.3.3`
- `change(pkg-bash): Link bash to /usr/bin/sh`
- `fix(pkg-bash): Fix script for new upstream changes`
- `perf(pkg-bash): Optimize compiler flags`
- `refactor(pkg-bash): Simplify patch application logic`
- `remove(pkg-old): Remove deprecated package script`
- `docs: Document new build variables`
- `ci: Add build matrix for multiple architectures`
