"use strict"
const AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });
const documentClient = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });

exports.handler = async (event) => {
    console.log("ACA EMPIEZA EL METODO")
    let body = JSON.parse(event.body)
    const params = {
      TableName: "user_data",
      Item: {
        userID: 1234,
        name: body.name,
        apellido: body.apellido
      }
    };
    
    try {
      const data = await documentClient.put(params).promise();
      return data;
    } catch (err){
      return err;
    }
  }