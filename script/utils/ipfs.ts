import { create } from 'ipfs';

async function startIpfs() {
  try {
    const ipfs = await create({
        // start: false,
        repo: './ipfs-data', // 데이터 저장 경로 지정
        offline: true,
        // config: {
        //     Addresses: {
        //         Swarm: [
        //             '/ip4/0.0.0.0/tcp/4002',
        //             '/ip4/127.0.0.1/tcp/4003/ws'
        //         ],
        //         API: '/ip4/0.0.0.0/tcp/5001',
        //         Gateway: '/ip4/127.0.0.1/tcp/8080',
        //     },
            
        // }
    });

    console.log('IPFS node is ready');

    // 노드 상태 확인
    const id = await ipfs.id();
    console.log('IPFS node id:', id.id);

    // ipfs.start();
  } catch (error) {
    console.error('Error starting IPFS node:', error);
  }
}

startIpfs();