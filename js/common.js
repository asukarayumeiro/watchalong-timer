import "@fortawesome/fontawesome-free/css/fontawesome.css";
import "@fortawesome/fontawesome-free/css/brands.css";
import "@fortawesome/fontawesome-free/css/solid.css";
import "../css/main.scss";

const parseParams = () => {
  const searchParams = (new URL(document.location)).searchParams;

  const parseInit = (s) => {
    if (s) {
      const n = parseInt(s, 10);
      if (isNaN(n)) return null;
      return n;
    }
    return null;
  };

  return {
    init: parseInit(searchParams.get("init"))
  };
};

export const startElmApp = (mainModule) => {
  const app = mainModule.init({
    node: document.getElementById("root"),
    flags: null
  });

};