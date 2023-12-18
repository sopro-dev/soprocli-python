import grpc



from soprocli.sopro_pb2 import HealthRequest
from soprocli.sopro_pb2_grpc import SoproServiceStub


def run():
    # Create a channel with HTTP/2 support
    channel = grpc.secure_channel("localhost:8080", grpc.ssl_channel_credentials())

    # Create a gRPC stub
    stub = SoproServiceStub(channel)

    # Example: Call the PingPong RPC
    req = HealthRequest()
    resp = stub.PingPong(req)
    print("PingPong Response:", resp.message)


if __name__ == "__main__":
    run()
