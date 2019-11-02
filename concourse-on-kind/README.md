# concourse-on-kind

By the way it's a bad idea to lump your web, workers, and postgres db into the same chart in the same namespace. You should separate all these into their own deployments so you have more flexibility when something goes wrong... but it's localhost so _pfft_
