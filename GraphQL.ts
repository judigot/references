import { PrismaClient } from "@prisma/client";
import DatatypeParser from "@utilities/DatatypeParser";
import { graphql, buildSchema as gql } from "graphql";

const prisma = new PrismaClient();

const schema = /* GraphQL */ `
  type Order {
    order_id: ID!
    orderProducts: [OrderedProducts!]!
  }
  type OrderedProducts {
    id: ID!
    order_id: Int!
    product_id: Int!
    quantity: Int!
  }
  type Query {
    getHelloWorld(parameter: ID!): String
    getOrder(id: ID!): Order
  }
`;

// The rootValue provides a resolver function for each API endpoint
var rootValue = {
  getHelloWorld: ({ parameter }: { [key: string]: number }) => {
    return "Hello, World!";
  },
  getOrder: async ({ id }: { id: string }) => {
    const result: any = await prisma.order.findUnique({
      select: {
        order_id: true,
        orderProducts: {
          select: {
            id: true,
            order_id: true,
            product_id: true,
            quantity: true,
          },
        },
      },
      where: {
        order_id: parseInt(id),
      },
    });
    return DatatypeParser(result);
  },
};

const order = async () => {
  const orderId = 1;
  const query = /* GraphQL */ `
      query {
        getOrder(id: ${orderId}) {
          order_id
          orderProducts {
            id
            order_id
            product_id
            quantity
          }
        }
      }
    `;
  try {
    // prettier-ignore
    // Destructuring nested objects
    const { data: { getOrder: order } }: any = await graphql({ schema: gql(schema), source: query, rootValue });
    return order;
  } catch (error) {
    return error;
  }
};