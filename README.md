# ARC Windows Runner (Sample)

## About

This provides a sample implementation of a containerized Windows-based Actions runner for [GitHub Actions Runner Controller](https://github.com/actions/actions-runner-controller). The build process for the image uses the latest version of the [Actions Runner](https://github.com/actions/runner), assigning a `latest` tag and a tag for the runner version. Runner images should ideally be rebuilt daily using a scheduled task to ensure that images are never more than 24 hours behind the current versions. Runners should be updated [at least every 30 days](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/autoscaling-with-self-hosted-runners#controlling-runner-software-updates-on-self-hosted-runners) to avoid the risk of the runner not being able to accept jobs.  

There are some additional notes included in the [Dockerfile](./Dockerfile) about the image and the steps for creating that image. Be aware that Windows containers behave very differently from Linux containers (both in level of API support and performance). I recommend considering a GitHub hosted runner for Windows builds whenever possible to have faster build times and access to the broader OS APIs and features.

## Support

This project is a sample and is not actively supported or maintained (see [SUPPORT](SUPPORT.md)). It is not supported or officially endorsed by GitHub.
