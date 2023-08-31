import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function seed(): Promise<void> {
  console.info(`Seeding database...`);
  await new Promise((resolve) => resolve(true));
  console.info(`Database has been seeded. 🌱`);
}

seed()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    return;
  });

