# akamai_api
bash shell tools for akamai api

## Features:
1. Purge Request (POST api.ccu.akamai.com/ccu/v2/queues/default) - Submits a request to purge Edge content represented by one or more ARLs/URLs or one or more CP codes. The Akamai network then processes the requests looking for matching content. If the network finds matching content, it is either removed or invalidated, as specified in the request.
2. Purge Status (GET api.ccu.akamai.com/ccu/v2/purges/<purgeId>) - Each purge request returns a link to the status information for that request. Use the Purge Status API to request that status information.
3. Queue Length (GET api.ccu.akamai.com/ccu/v2/queues/default) - Returns the number of outstanding objects in the user's queue.


## Usage:
 ./akamai_api.sh Commands [Options]

### Commands:
 1. purge_by_cpcod
 2. purge_by_object
 3. purge_status
 4. queue_length

### Options: 
 1. -h | -help        - This help text 
 2. -u                - akamai user name 
 3. -p                - akamai user password 
 4. -cpcode           - akamai opcode 
 5. -object           - akamai object 

#### eg: 
 ./akamai_api.sh purge_by_cpcode -u aaa -p pwd -cpcode 0000
 
