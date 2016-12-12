#! /bin/bash
# akamai cdn api
# by: chenyansheng
# date: 20161212

# akamai api
URL="curl https://api.ccu.akamai.com/ccu/v2/queues/default"
# request api http header
HTTP_HEADER="Content-Type:application/json"
# akamai user
USER=
# akamai password
PASSWORD=
# akamai opcode
CPCODE=
# purge object
OBJECT=
# request api return
RET=

usage() {
    echo "==============================================================================="
    echo "The Content Control Utility (CCU) is Akamai's technology for purging Edge content by request. The Luna Control Center provides a graphical interface to CCU for content administrators. The CCU REST API provides a programmatic interface for developers."
    echo "request api."
    echo "usage:"
    echo " $0 Commands [Options]"
    echo ""
    echo "Commands:"
    echo "  purge_by_cpcode"
    echo "  purge_by_object"
    echo "  purge_status"
    echo "  queue_length"
    echo ""
    echo "Options:"
    echo " -h | -help       - This help text"
    echo " -u               - akamai user name"
    echo " -p               - akamai user password"
    echo " -cpcode          - akamai opcode"
    echo " -object          - akamai object"
    echo ""
    echo "eg: "
    echo " $0 purge_by_cpcode -u aaa -p pwd -cpcode 0000"
    echo "==============================================================================="
}

parse_args() {
    if [ $# -lt 2 ]; then
        usage
        exit 0
    fi
    ACTION=$1
    shift
    while [ $# -ne 0 ] ; do
        PARAM=$1
        shift
        case $PARAM in
            -u)
                USER=$1
                shift
                ;;
            -p)
                PASSWORD=$1
                shift
                ;;
            -cpcode)
                CPCODE=$1
                shift
                ;;
            -object)
                OBJECT=$1
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                ;;
        esac
    done
}

check_params() {
    [ -z "${USER}" ] && error "Options -u is required"
    [ -z "$PASSWORD" ] && error "Options -p is required"

    case ${ACTION} in
        "purge_by_cpcode")
            [ -z "${CPCODE}" ] && error "Options -cpcode required when action is purge_by_cpcode"
            ;;
        "purge_by_object")
            [ -z "${OBJECT}" ] && error "Options -object required when action is purge_by_object"
            ;;
        *)
            error "Other action has not developed"
            ;;
    esac
}

# print error info
error() {
    echo "[1;41m[错误][0m $1"
    exit 1
}

# print info
info() {
    echo "[1;42m[信息][0m $@"
}

purge_by_cpcode() {
    # echo "curl ${URL} -H \"${HTTP_HEADER}\" -d '{\"type\" : \"cpcode\", \"objects\" : [\"${CPCODE}\"]}' -u ${USER}:'${PASSWORD}'"
    RET=`curl ${URL} -H "${HTTP_HEADER}" -d '{"type" : "cpcode", "objects" : ["${CPCODE}"]}' -u ${USER}:'${PASSWORD}' 2> /dev/null`
}

purge_by_object() {
    # echo "curl ${URL} -H \"${HTTP_HEADER}\" -d '{\"objects\" : [\"${OBJECT}\"]}' -u ${USER}:'${PASSWORD}'"
    RET=`curl ${URL} -H "${HTTP_HEADER}" -d '{"objects" : ["${OBJECT}"]}' -u ${USER}:'${PASSWORD}' 2> /dev/null`
}

do_action() {
    case ${ACTION} in
        "purge_by_cpcode")
            purge_by_cpcode
            ;;
        "purge_by_object")
            purge_by_object
            ;;
        *)
            error "Other action has not developed"
            ;;
    esac
}


parse_args $@
check_params
do_action

echo ${RET} | grep '"httpStatus": 201' > /dev/null
if [ $? -ne 0 ]; then
    error "${RET}"
else
    info "${RET}"
fi
