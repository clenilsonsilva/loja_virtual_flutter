import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import {
  CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands}
  from "cielo";

admin.initializeApp(functions.config().firebase);

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

const merchantId = functions.config().cielo.merchantId;
const merchantKey = functions.config().cielo.merchantKey;

const cieloParams: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: true,
  debug: true,
};

const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = functions.https.onCall(async (da, con) => {
  if (da === null) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados nao informados",
      },
    };
  }
  if (!con.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Nenhum usuario logado",
      },
    };
  }

  const userId = con.auth.uid;

  const snapSh = await admin.firestore().collection("users").doc(userId).get();
  const userData = snapSh.data() || {};

  console.log("Iniciando autorizacao");

  let brand: EnumBrands;
  switch (da.creditCard.brand) {
  case "VISA":
    brand = EnumBrands.VISA;
    break;
  case "MASTERCARD":
    brand = EnumBrands.MASTER;
    break;
  case "AMEX":
    brand = EnumBrands.AMEX;
    break;
  case "ELO":
    brand = EnumBrands.ELO;
    break;
  case "JCB":
    brand = EnumBrands.JCB;
    break;
  case "DINERSCLUB":
    brand = EnumBrands.DINERS;
    break;
  case "DISCOVER":
    brand = EnumBrands.DISCOVER;
    break;
  case "HIPERCARD":
    brand = EnumBrands.HIPERCARD;
    break;
  default:
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Cartao nao suportado" + da.creditCard.brand,
      },
    };
  }

  const saleData: TransactionCreditCardRequestModel = {
    merchantOrderId: da.merchantOrderId,
    customer: {
      nome: userData.name,
      identity: da.cpf,
      identityType: "CPF",
      email: userData.email,
      deliveryAddress: {
        street: userData.address.street,
        number: userData.address.number,
        complement: userData.address.complement,
        zipCode: userData.address.zipCode.replace(".", "").replace("-", ""),
        city: userData.address.city,
        state: userData.state,
        country: "BRA",
        district: userData.address.district,
      },
    },
    payment: {
      currency: "BRL",
      country: "BRA",
      amount: da.amount,
      installments: da.installment,
      softDescriptor: da.softDescriptor,
      type: da.paymentType,
      capture: false,
      creditCard: {
        cardNumber: da.creditCard.cardNumber,
        holder: da.creditCard.holder,
        expirationDate: da.creditCard.expirationDate,
        securityCode: da.creditCard.securityCode,
        brand: brand,
      },
    },
  };
  try {
    const transaction = await cielo.creditCard.transaction(saleData);

    if (transaction.payment.status === 1) {
      return {
        "success": true,
        "paymentId": transaction.payment.paymentId,
      };
    } else {
      let message = "";
      switch (transaction.payment.returnCode) {
      case "5":
        message = "Não Autorizada";
        break;
      case "57":
        message = "Cartão Expirado";
        break;
      case "78":
        message = "Cartão Bloqueado";
        break;
      case "99":
        message = "Timeout";
        break;
      case "77":
        message = "Cartão Cancelado";
        break;
      case "70":
        message = "Problemas com o Cartão de Crédito";
        break;
      default:
        message = transaction.payment.returnMessage;
        break;
      }
      return {
        "success": false,
        "status": transaction.payment.status,
        "error": {
          "code": transaction.payment.returnCode,
          "message": message,
        },
      };
    }
  } catch (error) {
    console.error("Error ", error);
    return {
      "sucess": false,
      "error": {
        "code": error,
        "message": error,
      },
    };
  }
});

export const helloWorld = functions.https.onCall((data, context) => {
  return {data: "Hello from cloud functions"};
});

export const getUserData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    return {"data": "Nenhum usuario logado"};
  }
  const snapshot = await admin.firestore().collection("users")
    .doc(context.auth.uid).get();
  return {"data": snapshot.data()};
});

export const addMessage = functions.https.onCall(async (data, context) => {
  console.log(data);

  const snapshot = await admin.firestore().collection("messages").add(data);
  return {"success": snapshot.id};
});

export const onNewOrder = functions.firestore.document("orders/{orderId}")
  .onCreate((snapshot, context) => {
    const orderId = context.params.orderId;
    console.log(orderId);
  });
