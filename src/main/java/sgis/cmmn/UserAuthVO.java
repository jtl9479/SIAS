package sgis.cmmn;

import org.springframework.security.core.GrantedAuthority;

public class UserAuthVO implements GrantedAuthority {

	private static final long serialVersionUID = 1L;
	
	private String username;
	
	@Override
	public String getAuthority() {
		// TODO Auto-generated method stub
		return this.username;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}


}
