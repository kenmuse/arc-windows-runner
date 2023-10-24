# ARC Windows Runner (Sample)

## About

This provides a sample implementation of a containerized Windows-based Actions runner for [GitHub Actions Runner Controller](https://github.com/actions/actions-runner-controller). The build process for the image uses the latest version of the [Actions Runner](https://github.com/actions/runner), assigning a `latest` tag and a tag for the runner version. Runner images should be rebuild daily using a scheduled task to ensure that images are never more than 24 hours behind the current versions. Runners must be updated [at least every 30 days](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/autoscaling-with-self-hosted-runners#controlling-runner-software-updates-on-self-hosted-runners).

## Support

This project is a sample and is not actively supported or maintained (see [SUPPORT](SUPPORT.md)). It is not supported or officially endorsed by GitHub.
