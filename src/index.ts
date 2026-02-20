import { Container, getContainer } from "@cloudflare/containers";

// 1. Define the Container class (backed by the Durable Object)
export class DvwaContainer extends Container {
  // DVWA listens on port 80 internally
  defaultPort = 80;
  // Put the container to sleep after 10 minutes of inactivity to save compute costs
  sleepAfter = "10m"; 
}

export default {
  async fetch(request: Request, env: any) {
    // 2. Get the container instance. 
    const containerInstance = getContainer(env.DVWA_CONTAINER, "dvwa-instance");

    try {
      // 3. Proxy the user's request directly into the Docker container
      return await containerInstance.fetch(request);
    } catch (e) {
      return new Response("Container is booting up. Please refresh in 5 seconds...", { 
        status: 503 
      });
    }
  },
};