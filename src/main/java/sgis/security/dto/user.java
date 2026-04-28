package sgis.security.dto;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class user implements UserDetails{
	
	//거래처코드
	String bcncCode;
	//ID
	String username;
	//PW
	String password;
	//사용유무
	String useAt;
	//권한값
	private String authority;
	//사업자번호
	String bizrNo;
	//상호
	String cmpNm;
	//납기일자최소일자
	String dedtMummDe;
	//납기일자기준시간
	String dedtStdrTime;
	//등록사업장
	String registBplc;
	//사용자, 관리자 구분
	String userSe;
	//최소주문량
	int mummOrderQy;
	//미수금 (true 일경우 미수금 있음, false일 경우 미수금 없음)
	boolean unColectMoney;
	//미수금 합계  (미수금이 존재할 경우 제품 주문등록시 차액 계산 시 필요)
	String unColectMoneyAm;
	//주문사업장명칭(엑셀업로드에서 사용)
	String ordBplcNm;
	//접근권한
	String accesAuthor;
	//출고정지
	String dlivyStopAt;
	//어음한도
	String bilLmt;
	//외상한도
	String crdtLmt;
	
	private boolean enabled = true;

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority(this.getAuthority()));
		return authorities;
	}

	@Override
	public String getPassword() {
		// TODO Auto-generated method stub
		return password;
	}

	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return username;
	}

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getBcncCode() {
		return bcncCode;
	}

	public void setBcncCode(String bcncCode) {
		this.bcncCode = bcncCode;
	}

	public String getUseAt() {
		return useAt;
	}

	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	
	public String getAuthority() {
		return authority;
	}

	public void setAuthority(String authority) {
		this.authority = authority;
	}

	public String getBizrNo() {
		return bizrNo;
	}

	public void setBizrNo(String bizrNo) {
		this.bizrNo = bizrNo;
	}

	public String getCmpNm() {
		return cmpNm;
	}

	public void setCmpNm(String cmpNm) {
		this.cmpNm = cmpNm;
	}
	
	public String getDedtMummDe() {
		return dedtMummDe;
	}

	public void setDedtMummDe(String dedtMummDe) {
		this.dedtMummDe = dedtMummDe;
	}

	public String getDedtStdrTime() {
		return dedtStdrTime;
	}

	public void setDedtStdrTime(String dedtStdrTime) {
		this.dedtStdrTime = dedtStdrTime;
	}

	public String getRegistBplc() {
		return registBplc;
	}

	public void setRegistBplc(String registBplc) {
		this.registBplc = registBplc;
	}
	
	public String getUserSe() {
		return userSe;
	}

	public void setUserSe(String userSe) {
		this.userSe = userSe;
	}
	
	public int getMummOrderQy() {
		return mummOrderQy;
	}

	public void setMummOrderQy(int mummOrderQy) {
		this.mummOrderQy = mummOrderQy;
	}

	public boolean getUnColectMoney() {
		return unColectMoney;
	}

	public void setUnColectMoney(boolean unColectMoney) {
		this.unColectMoney = unColectMoney;
	}
	
	public String getUnColectMoneyAm() {
		return unColectMoneyAm;
	}

	public void setUnColectMoneyAm(String unColectMoneyAm) {
		this.unColectMoneyAm = unColectMoneyAm;
	}

	public String getOrdBplcNm() {
		return ordBplcNm;
	}

	public void setOrdBplcNm(String ordBplcNm) {
		this.ordBplcNm = ordBplcNm;
	}
	
	public String getAccesAuthor() {
		return accesAuthor;
	}

	public void setAccesAuthor(String accesAuthor) {
		this.accesAuthor = accesAuthor;
	}

	public String getDlivyStopAt() {
		return dlivyStopAt;
	}

	public void setDlivyStopAt(String dlivyStopAt) {
		this.dlivyStopAt = dlivyStopAt;
	}

	public String getBilLmt() {
		return bilLmt;
	}

	public void setBilLmt(String bilLmt) {
		this.bilLmt = bilLmt;
	}

	public String getCrdtLmt() {
		return crdtLmt;
	}

	public void setCrdtLmt(String crdtLmt) {
		this.crdtLmt = crdtLmt;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return this.enabled;
	}
	
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

}
