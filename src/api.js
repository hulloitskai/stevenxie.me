// eslint-disable-next-line no-unused-vars
import { create, AxiosInstance } from "axios";

export const baseURL = process.env.VUE_APP_API_BASE_URL;
if (!baseURL) throw new Error("api: invalid base URL");

/** @type {AxiosInstance} */
export const client = create({ baseURL });

export const wsBaseURL = baseURL.startsWith("https")
  ? `wss${baseURL.slice(5)}`
  : `ws${baseURL.slice(4)}`;
