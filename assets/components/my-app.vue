<template>
  <div id="my-app">

    <div class="row expanded">
      <div class="small-offset-10 small-2 columns">
        <span class="label primary text-right">Last Updated: {{ lastUpdated ? lastUpdated.format('hh:mm:ss a') : 'N/A' }}</span>
      </div>
    </div>

    <div class="row expanded">
      <div class="small-12 medium-4 columns">
        <pingdom-widget :data="pingdom"></pingdom-widget>
      </div>

      <div class="small-12 medium-4 columns">
        <travis-widget :data="travis"></travis-widget>
      </div>

      <div class="small-12 medium-4 columns">
        <status-page-widget :data="status_page"></status-page-widget>
      </div>
    </div>

  </div>
</template>

<script>
export default {
  data() {
    return {
      pingdom: [{hostname: 'rawr.com', lastresponsetime: 250, status: 'up', tags: [], url: ''}, {hostname: 'down.com', lastresponsetime: 1000, status: 'down', tags: [], url: ''}],
      travis: [
    {
      "state": "errored",
      "slug": "CreditCardsCom/card-catalog",
      "href": "/repo/2492721",
      "author": {
        "name": "Matt McFarland",
        "avatar_url": "https://0.gravatar.com/avatar/b8f94bebb3c22103c9969f453226c1cb"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/canada",
      "href": "/repo/1834322",
      "author": {
        "name": "Rob McLaughlin IV",
        "avatar_url": "https://0.gravatar.com/avatar/7ad70b2653d39b917b6833d6034af043"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/document-manager",
      "href": "/repo/1816340",
      "author": {
        "name": "david.cannon",
        "avatar_url": "https://0.gravatar.com/avatar/1864f0fd3a4263d0a66bff335b903bd8"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/glados",
      "href": "/repo/1243036",
      "author": {
        "name": "david.cannon",
        "avatar_url": "https://0.gravatar.com/avatar/1864f0fd3a4263d0a66bff335b903bd8"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/cc-revenue-engine-ui",
      "href": "/repo/1864827",
      "author": {
        "name": "Samuel Bagot",
        "avatar_url": "https://0.gravatar.com/avatar/2ab1b526057a725ce37005e33a1d7e44"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/revenue-engine",
      "href": "/repo/2224903",
      "author": {
        "name": "Samuel Bagot",
        "avatar_url": "https://0.gravatar.com/avatar/2ab1b526057a725ce37005e33a1d7e44"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/feeds",
      "href": "/repo/1298461",
      "author": {
        "name": "Jason Huie",
        "avatar_url": "https://0.gravatar.com/avatar/b1df2b6d29392fe5daa06bc95b332b9a"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/automation-tests",
      "href": "/repo/1549313",
      "author": {
        "name": "Anna Kruglyanskaya",
        "avatar_url": "https://0.gravatar.com/avatar/0a25d235aa37dd0e27948cd245d9d719"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/viewbook",
      "href": "/repo/1640655",
      "author": {
        "name": "Mitchell Stoutin",
        "avatar_url": "https://0.gravatar.com/avatar/0b6069049e5c69c125eb21831bcc43e4"
      }
    },
    {
      "state": "failed",
      "slug": "CreditCardsCom/parsing-service",
      "href": "/repo/1803385",
      "author": {
        "name": "Michael Peck",
        "avatar_url": "https://0.gravatar.com/avatar/a2bac82b510e91064f759f26895b4583"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/viewbook-mock-data",
      "href": "/repo/2408187",
      "author": {
        "name": "Mitchell Stoutin",
        "avatar_url": "https://0.gravatar.com/avatar/0b6069049e5c69c125eb21831bcc43e4"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/viewbook-server",
      "href": "/repo/2257032",
      "author": {
        "name": "Matt McFarland",
        "avatar_url": "https://0.gravatar.com/avatar/b8f94bebb3c22103c9969f453226c1cb"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/keycloak-cccom",
      "href": "/repo/2240010",
      "author": {
        "name": "Matt McFarland",
        "avatar_url": "https://0.gravatar.com/avatar/b8f94bebb3c22103c9969f453226c1cb"
      }
    },
    {
      "state": "passed",
      "slug": "CreditCardsCom/reveng-core-api",
      "href": "/repo/1870258",
      "author": {
        "name": "Matt McFarland",
        "avatar_url": "https://0.gravatar.com/avatar/b8f94bebb3c22103c9969f453226c1cb"
      }
    },
    {
      "state": "errored",
      "slug": "CreditCardsCom/jsonapi-response-builder",
      "href": "/repo/2112576",
      "author": {
        "name": "Daniel Knight",
        "avatar_url": "https://0.gravatar.com/avatar/d0591a3b4e4732de56fb541ac0f29740"
      }
    }
  ],
      status_page: [
    {
      "status": "operational",
      "name": "CreditCard Forum Blog",
      "description": "www.creditcardforum.com/blog/"
    },
    {
      "status": "operational",
      "name": "CreditCard Forum",
      "description": "www.creditcardforum.com"
    },
    {
      "status": "operational",
      "name": "Compare and Save",
      "description": "www.compareandsave.com"
    },
    {
      "status": "operational",
      "name": "Freedom Marketing",
      "description": "www.freedommarketing.co.uk"
    },
    {
      "status": "operational",
      "name": "AWS ec2-us-east-1"
    },
    {
      "status": "operational",
      "name": "AWS cloudFront"
    },
    {
      "status": "operational",
      "name": "CardMatch"
    },
    {
      "status": "operational",
      "name": "Card Reviews",
      "description": "www.creditcards.com/reviews"
    },
    {
      "status": "operational",
      "name": "Clicks API Endpoint",
      "description": "feeds.linkoffers.com"
    },
    {
      "status": "operational",
      "name": "Products API Endpoint",
      "description": "feeds.linkoffers.com"
    }
  ],
      lastUpdated: null
    }
  },

   mounted() {
    this.channel = socket.channel("backend:sync", {});

    this.channel.join()
      .receive("ok", response => { console.log("Joined successfully", response) })
      .receive("error", response => { console.log("Unable to join", response) });

    this.channel.on('pingdom', payload => {
      this.pingdom = payload.data;
      this.lastUpdated = moment();
    });
    this.channel.on('travis', payload => {
      this.travis = payload.data;
      this.lastUpdated = moment();
    });
    this.channel.on('status_page', payload => {
      this.status_page = payload.data;
      this.lastUpdated = moment();
    });
  },

  render(createElement) {
    return createElement(MyApp, {})
  }
}
</script>
