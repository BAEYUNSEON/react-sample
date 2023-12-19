import logo from './kyobo_logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        {/* <img src={logo} className="App-logo" alt="logo" /> */}
        <img src={logo}  alt="logo" />
        <p>
        간편 보험료 설계, 종신보험, 정기보험, 연금보험, 퇴직연금, 보험계약대출, 마이데이터 자산관리.
        </p>
        <a
          className="App-link"
          href="https://www.kyobo.com/"
          target="_blank"
          rel="noopener noreferrer"
        >
          KYOBO 교보생명 바로가기
        </a>
      </header>
    </div>
  );
}

export default App;
