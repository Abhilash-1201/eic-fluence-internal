cloudWatch:
  region: ${region}
  logGroupName: ${logGroupName}
  logRetentionDays: 7

serviceAccount:
  create: false
  name: fluentbit-sa

