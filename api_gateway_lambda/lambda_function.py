def lambda_handler(event, context):
    print(">>> event = " + str(event), " context = " + str(context))
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }