package sgis.cmmn;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class UserDetailsVO implements UserDetails {
	
	private static final long serialVersionUID = 1L;
	
	private String username; 
	private String password;
	private String roleauth;
	private String addr;
	private String sex;
	private List<UserAuthVO> authorities;
	private boolean accountNonExpired = true; 
	private boolean accountNonLocked = true; 
	private boolean credentialsNonExpired = true; 
	private boolean enabled = true;

	
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}

	@Override public Collection<? extends GrantedAuthority> getAuthorities() { 
		return this.authorities; } 
	
	public void setAuthorities(List<UserAuthVO> authorities) { 
		this.authorities = authorities; 
	} 
	
	@Override public boolean isAccountNonExpired() { 
		return this.accountNonExpired; 
	}
	
	public void setAccountNonExpired(boolean accountNonExpired) { 
		this.accountNonExpired = accountNonExpired; 
	} 
	
	@Override public boolean isAccountNonLocked() {
		return this.accountNonLocked; 
	} 
	
	public void setAccountNonLocked(boolean accountNonLocked) { 
		this.accountNonLocked = accountNonLocked; 
	}
	
	@Override 
	public boolean isCredentialsNonExpired() {
		return this.credentialsNonExpired;
	} 
	
	public void setCredentialsNonExpired(boolean credentialsNonExpired) {
		this.credentialsNonExpired = credentialsNonExpired; 
	} 
	
	@Override 
	public boolean isEnabled() { 
		return this.enabled; 
	} 
	
	public void setEnabled(boolean enabled) { 
		this.enabled = enabled;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getRoleauth() {
		return roleauth;
	}
	public void setRoleauth(String roleauth) {
		this.roleauth = roleauth;
	}
	
}
